# frozen_string_literal: true

RSpec.describe Airtel::Pesa do
  before do
    Airtel::Pesa.configure do |configuration|
      configuration.client_id        = "Azs2KejU1ARvIL5JdJsARbV2gDrWmpOB"
      configuration.client_secret     = "hipGvFJbOxri330c"
      configuration.pass_key            = "bfb279f9aa9bdbcf158e97dd71a467cd2e0c893059b10f78e6b72ada1ed2c919"
      configuration.short_code          = 174379
      configuration.response_type       = "Completed"
      configuration.callback_url        = "https://example.com/callback"
      configuration.queue_time_out_url  = "https://example.com/callback"
      configuration.result_url          = "https://example.com/callback"
      configuration.default_description = "Payment of X"
      configuration.enviroment          = "sandbox"
    end
  end

  it "has a version number" do
    expect(Airtel::Pesa::VERSION).not_to be nil
  end

  it "returns an access token on authorization" do
    expect(Airtel::Pesa::Authorization.call.result.access_token).not_to be nil
  end

  it "returns an expires in on authorization" do
    expect(Airtel::Pesa::Authorization.call.result.expires_in).not_to be nil
  end
end
