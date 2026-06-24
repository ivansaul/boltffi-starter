use serde::Deserialize;

#[boltffi::data]
#[derive(Debug, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct Quote {
    #[serde(rename = "_id")]
    pub id: String,
    pub content: String,
    pub author: String,
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
