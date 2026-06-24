pub mod error;
pub mod models;
mod service;

use crate::{error::DemoCoreError, quotes::models::Quote};
use demo_http::HttpClient;

pub struct QuotesClient {
    service: service::QuotesService,
}

#[boltffi::export]
impl QuotesClient {
    pub fn new() -> Self {
        Self {
            service: service::QuotesService::new(HttpClient::new()),
        }
    }

    #[demo_macros::tokio_runtime]
    pub async fn random_quote(&self) -> Result<Quote, DemoCoreError> {
        Ok(self.service.random_quote().await?)
    }
}
