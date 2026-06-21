use serde::Deserialize;

#[boltffi::data]
#[derive(Debug, Deserialize)]
pub struct Joke {
    pub id: i64,
    #[serde(rename = "type")]
    pub category: String,
    pub setup: String,
    pub punchline: String,
}
