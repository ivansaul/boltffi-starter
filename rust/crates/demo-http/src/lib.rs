pub struct HttpClient {
    client: reqwest::Client,
}

impl HttpClient {
    pub fn new() -> Self {
        Self {
            client: reqwest::Client::new(),
        }
    }

    pub async fn get<T>(&self, url: &str) -> Result<T, NetworkError>
    where
        T: for<'de> serde::Deserialize<'de>,
    {
        let response = self.client.get(url).send().await?;
        let text = response.text().await?;
        let result: T = serde_json::from_str(&text)?;
        Ok(result)
    }
}

#[derive(Debug)]
pub enum NetworkError {
    Timeout,
    ConnectionFailed,
    InvalidResponse,
}

impl From<reqwest::Error> for NetworkError {
    fn from(err: reqwest::Error) -> Self {
        if err.is_timeout() {
            Self::Timeout
        } else if err.is_decode() {
            Self::InvalidResponse
        } else {
            Self::ConnectionFailed
        }
    }
}

impl From<serde_json::Error> for NetworkError {
    fn from(_: serde_json::Error) -> Self {
        Self::InvalidResponse
    }
}
