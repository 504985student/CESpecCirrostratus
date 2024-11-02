provider "google" {
    credentials = file("/credentials.json")
    project     = "smart-seer-434509-i6"
    region      = "europe-west1"
}