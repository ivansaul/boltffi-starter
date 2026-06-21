use demo_common::joke::Joke;
use demo_http::{HttpClient, NetworkError};

#[boltffi::error]
#[derive(Debug, Clone, thiserror::Error)]
pub enum JokeError {
    #[error("no joke available")]
    Unavailable,
    #[error("invalid joke")]
    InvalidJoke,
}

impl From<NetworkError> for JokeError {
    fn from(error: NetworkError) -> Self {
        match error {
            NetworkError::Timeout => JokeError::Unavailable,
            NetworkError::ConnectionFailed => JokeError::Unavailable,
            NetworkError::InvalidResponse => JokeError::InvalidJoke,
        }
    }
}

pub(crate) struct JokeService {
    http: HttpClient,
}

impl JokeService {
    pub fn new(http: HttpClient) -> Self {
        Self { http }
    }

    pub async fn random_joke(&self) -> Result<Joke, JokeError> {
        let joke: Joke = self
            .http
            .get("https://official-joke-api.appspot.com/jokes/random/")
            .await?;
        Ok(joke)
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[tokio::test]
    async fn test_random_joke() {
        let joke = JokeService::new(HttpClient::new()).random_joke().await;
        dbg!(&joke);
        assert!(joke.is_ok());
    }
}

// ======================================================

pub struct JokeManager {
    service: JokeService,
}

#[boltffi::export]
impl JokeManager {
    pub fn new() -> Self {
        Self {
            service: JokeService::new(HttpClient::new()),
        }
    }

    pub async fn random_joke(&self) -> Result<Joke, JokeError> {
        self.service.random_joke().await
    }

    #[demo_macros::tokio_ffi]
    pub async fn random_joke2(&self) -> Result<Joke, JokeError> {
        self.service.random_joke().await
    }
}
