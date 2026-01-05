use stubs::weapon;
use stubs::weapon::v0::weapon_service_server::WeaponService;
use tonic::{Request, Response, Status};

use super::MissionRpc;

#[tonic::async_trait]
impl WeaponService for MissionRpc {
    async fn get_transform(
        &self,
        request: Request<weapon::v0::GetWeaponTransformRequest>,
    ) -> Result<Response<weapon::v0::GetWeaponTransformResponse>, Status> {
        let res = self.request("getWeaponTransform", request).await?;
        Ok(Response::new(res))
    }
}
