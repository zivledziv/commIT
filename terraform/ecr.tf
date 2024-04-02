# # --- ECR - commit-frontend ---
# resource "aws_ecr_repository" "commit-frontend" {
#   name                 = "commit-frontend"
#   image_tag_mutability = "MUTABLE"
#   force_delete         = true

#   image_scanning_configuration {
#     scan_on_push = true
#   }
# }

# # --- ECR - commit-backend ---
# resource "aws_ecr_repository" "commit-backend" {
#   name                 = "commit-backend"
#   image_tag_mutability = "MUTABLE"
#   force_delete         = true

#   image_scanning_configuration {
#     scan_on_push = true
#   }
# }

# output "commit-frontend_repo_url" {
#   value = aws_ecr_repository.commit-frontend.repository_url
# }

# output "commit-backend_repo_url" {
#   value = aws_ecr_repository.commit-backend.repository_url
# }