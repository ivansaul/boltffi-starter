use crate::quotes::{error::QuotesError, models::Quote};
use demo_http::{HttpClient, HttpError};

pub struct QuotesService {
    client: HttpClient,
}

impl QuotesService {
    pub fn new(http: HttpClient) -> Self {
        Self { client: http }
    }

    #[tracing::instrument(err(Debug), skip(self))]
    pub async fn random_quote(&self) -> Result<Quote, QuotesError> {
        self.client
            .get::<Quote>("https://api.quotable.io/random")
            .await
            .map_err(|error| match error {
                HttpError::NotFound => QuotesError::Unavailable,
                HttpError::Network(_) => QuotesError::Unavailable,
                HttpError::Decode(_) => QuotesError::InvalidResponse,
                _ => QuotesError::Unknown(format!("{:?}", error)),
            })
    }
}

#[cfg(test)]
mod tests {

    use super::*;

    #[tokio::test]
    async fn test_random_quote() -> Result<(), Box<dyn std::error::Error>> {
        let service = QuotesService::new(HttpClient::new());
        let quote = service.random_quote().await?;
        dbg!(&quote);
        Ok(())
    }
}
