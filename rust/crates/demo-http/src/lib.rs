pub struct HttpClient {
    client: reqwest::Client,
}

impl HttpClient {
    pub fn new() -> Self {
        Self {
            client: reqwest::Client::new(),
        }
    }

    #[tracing::instrument(err(Debug), skip(self))]
    pub async fn get<T>(&self, url: &str) -> Result<T, HttpError>
    where
        T: serde::de::DeserializeOwned,
    {
        let response = self
            .client
            .get(url)
            .send()
            .await
            .map_err(map_network_error)?;

        let status = response.status();

        if status.is_success() {
            let body = response.text().await.map_err(map_network_error)?;
            let data = serde_json::from_str::<T>(&body).map_err(HttpError::Decode)?;
            return Ok(data);
        }

        match status.as_u16() {
            401 => Err(HttpError::Unauthorized),
            403 => Err(HttpError::Forbidden),
            404 => Err(HttpError::NotFound),
            500..=599 => Err(HttpError::Server(status.as_u16())),
            code => Err(HttpError::UnexpectedStatus(code)),
        }
    }
}

#[derive(Debug, thiserror::Error)]
pub enum HttpError {
    #[error("network error")]
    Network(#[from] NetworkError),

    #[error("unauthorized")]
    Unauthorized,

    #[error("forbidden")]
    Forbidden,

    #[error("not found")]
    NotFound,

    #[error("server error: {0}")]
    Server(u16),

    #[error("decode error")]
    Decode(#[from] serde_json::Error),

    #[error("unexpected status: {0}")]
    UnexpectedStatus(u16),
}

#[derive(Debug, thiserror::Error)]
pub enum NetworkError {
    #[error("timeout")]
    Timeout,

    #[error("offline")]
    Offline,

    #[error("transport error")]
    Transport(#[from] reqwest::Error),
}

fn map_network_error(err: reqwest::Error) -> HttpError {
    if err.is_timeout() {
        HttpError::Network(NetworkError::Timeout)
    } else if err.is_connect() {
        HttpError::Network(NetworkError::Offline)
    } else {
        HttpError::Network(NetworkError::Transport(err))
    }
}
