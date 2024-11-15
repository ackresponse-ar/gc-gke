provider "google" {
  project     = "concepts-demo"
  credentials = file("gcp-ar-key.json")
}