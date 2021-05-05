resource "random_id" "id" {
  prefix      = var.project_name
  byte_length = 4
}

resource "google_project" "project" {
  name            = var.project_name
  org_id          = var.org_id
  project_id      = random_id.id.hex
  billing_account = var.billing_account
}

resource "google_project_service" "service" {
  for_each = toset([
    "compute.googleapis.com"
  ])

  service = each.key
  project = google_project.project.project_id

  disable_on_destroy = false
}

resource "google_compute_project_metadata" "metadata" {
  project = google_project.project.project_id 
  metadata = {
    startup-script-url = "${google_storage_bucket.project_bucket.url}/${google_storage_bucket_object.startup.output_name}"
    ssh-keys = <<EOF
james:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAH9syQ/aDnDSS4KQwSz5BOW4QlECSgCq92JqnF1Id7mvvCoECB1j0KnQ7rLEIgx6lkuYSgZHGYoXDSuD8ibqgC2pAU66MbqbAC4usz7U0rqYhQX2G/KC7BBULMbrKi+WA6UYgOqHr5rJ59KTwWIGppB20AQTM7CD8lqQTjw+LvTvf4JvDHhUrSliImItX4pRagPQxL2+Veyvgr+kk/oUfVUOetJx9NJK/mI8lConO6XVsREjP9/+zcovAUqctWnrIzvZ42jU7HxHdEhzRzfYldzo55GldqYBXgwrOcR7T48p5zT6pePitMVTKVkceO8P3+LDfgAbEu6xTKUXptdmwtE= google-ssh {"userName":"james@reebric.com","expireOn":"2020-03-22T18:10:06+0000"}
james:ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBBcPguMS7Qmv7nDYUbbVKcVTzDH63MHvmd1iWBPBKyfw7nfi5u5fxz1rBp6U4MbUl1hyAvyYJfPr80K5AtBz9kE= google-ssh {"userName":"james@reebric.com","expireOn":"2020-03-22T18:10:04+0000"}
james:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCF0td1qrEqE468sEdwf3MdzODsfl/Ui3rU3t+fCgOMyvbYx08cS4uONAFQly1wNop6bKVcbj0AhPuGxAmKkNCchWPmxl/nZuXna0EtlgkRuqswxXsDQb2GoKGgbLyLukLwzhNYMyXJyKrkTzpZRZpYaGjq780Hj68qVPFDVcrWxTLZqUtVEu6rMv6m3XOynQz4un1uMmX3wnMUPFXSaV4HFjupqkyFyDb9vpzMCBvnRXlV5eGRvIgmQkh4GI93s6TAfVs/BZmbDel4bWqjVU9khBopRA2w3a4FhvzWZc+7ShbgO7OHo0fdRJ8Pdt9EyVMFr1BDcOIUK3BoZmcLDGqB google-ssh {"userName":"james@reebric.com","expireOn":"2020-03-22T18:08:12+0000"}
james:ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBCkr1ltlxDPy0yXnKpvo8GfxX5M05D8FYYqStmpasqVJ7Svl+3yI64FjIHW46cuCPj3XzxKj0dV9/dx2tLviqpU= google-ssh {"userName":"james@reebric.com","expireOn":"2020-03-22T18:08:08+0000"}
james:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB7zOql9P4RtKMk0Adh3OwRBCgqmyjqD2tHIJ6Zq/NIu james@home
james:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPceeomxGZ5P+BFM8JK4r4lmXzzVVVFkiWBbhGw3nVzn james@home2
james:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBpt9lI0ol2EGdQd7o2SuhjYwxk2P4uGkiFUgqvpqZfB james@beepboop
EOF
  }
}

data "google_compute_default_service_account" "default_sa" {
  project = google_project.project.project_id  
}
