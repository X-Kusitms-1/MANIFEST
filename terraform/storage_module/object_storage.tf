#######################################
# Object Storage (S3-compatible)
#######################################
resource "ncloud_objectstorage_bucket" "this" {
  bucket_name = var.bucket_name
  # 필요 시, CORS/정책/버전관리 리소스를 이 모듈에 추가 확장
}
