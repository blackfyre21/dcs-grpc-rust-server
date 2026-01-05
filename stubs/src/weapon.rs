pub mod v0 {
    use crate::common::v0::{RawTransform, Transform};

    tonic::include_proto!("dcs.weapon.v0");

    #[derive(serde::Deserialize)]
    #[serde(rename_all = "camelCase")]
    struct GetWeaponTransformResponseIntermediate {
        time: f64,
        raw_transform: Option<RawTransform>,
    }

    impl From<GetWeaponTransformResponseIntermediate> for GetWeaponTransformResponse {
        fn from(i: GetWeaponTransformResponseIntermediate) -> Self {
            let GetWeaponTransformResponseIntermediate {
                time,
                raw_transform,
            } = i;
            let transform = Transform::from(raw_transform.unwrap_or_default());
            GetWeaponTransformResponse {
                time,
                position: Some(transform.position),
                orientation: Some(transform.orientation),
                velocity: Some(transform.velocity),
            }
        }
    }
}
