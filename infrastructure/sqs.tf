resource "aws_sqs_queue" "job_queue" {
  # create sqs queue for conversion jobs
  name                      = "playlist-pigeon-job-queue-${var.env_name}"
  message_retention_seconds = 300
  receive_wait_time_seconds = 20
}