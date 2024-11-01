provider "google" {
    credentials = file("/<credentials>.json")
    project     = "<project>"
    region      = "europe-west1"
}