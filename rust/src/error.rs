use crate::quotes::error::QuotesError;

#[boltffi::error]
#[derive(Debug, thiserror::Error)]
pub enum DemoCoreError {
    #[error("quotes error: {0}")]
    QuotesError(#[from] QuotesError),
}
