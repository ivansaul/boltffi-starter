use serde::Deserialize;

#[boltffi::data]
#[derive(Debug, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct Quote {
    #[serde(default)]
    pub id: String,
    #[serde(rename = "q")]
    pub content: String,
    #[serde(rename = "a")]
    pub author: String,
    #[serde(default)]
    pub tags: Vec<String>,
}

#[boltffi::data(impl)]
impl Quote {
    pub fn place_holder() -> Self {
        Self {
            id: String::new(),
            content: String::new(),
            author: String::new(),
            tags: Vec::new(),
        }
    }
}
