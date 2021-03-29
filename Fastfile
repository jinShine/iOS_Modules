default_platform(:ios)

platform :ios do
  desc "Stage서버 테스트플라이트 업로드"
  lane :stage do
    increment_build_number
    build_app(
      scheme: "Consumer-Stage",
      workspace: "Consumer.xcworkspace",
      include_bitcode: true,
      xcargs: "-allowProvisioningUpdates",
      output_directory: "archives"
    )
    upload_to_testflight(
      app_identifier: "io.lific.consumer.stage",
      changelog: "Improvements and bug fixes"      
    )
    send_slack({"version": get_version_number })
  end

  lane :send_slack do |options|
    slack(
      message: "앱이 TestFlight에 성공적으로 업로드 되었습니다.",
      channel: "#dev-git",
      slack_url: ENV["SLACK_WEBHOOK_URL"],
      payload: {
        "Version": options[:version],
        "Build Date" => Time.new.to_s,
        "Built by" => "GitHub Action",
      }
    )
  end

  desc "AppStore 업로드"
  lane :release do
    increment_build_number
    build_app(
      scheme: "Consumer",
      workspace: "Consumer.xcworkspace",
      include_bitcode: true,
      xcargs: "-allowProvisioningUpdates",
      output_directory: "archives"
    )
    upload_to_app_store(
      force: true,
      skip_binary_upload: false, # 만약 메타 데이터만 itunesConnect에 업로드하고싶다면, 아래의 옵션을 true로 두어 .ipa 파일이 업로드 되지 않도록 합니다.
      skip_screenshots: true,
      automatic_release: true, # 자동으로 출시 여부
      submit_for_review: true, # 메타데이터와 빌드파일을 업로드 후 자동으로 제출 유무
      submission_information: { # 심사 시, IDFA(애플 광고 식별자)에 대한 정보입니다.
        add_id_info_uses_idfa: false,
        add_id_info_serves_ads: false,
        add_id_info_tracks_install: false,
        add_id_info_tracks_action: false,
        add_id_info_limits_tracking: false,
        export_compliance_uses_encryption: false,
      }
    )
  end

end
