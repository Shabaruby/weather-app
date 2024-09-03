# frozen_string_literal: true

RSpec.shared_examples 'successful weather request' do |cassette_name, endpoint, data_key, data_value, additional_params = {}|
  it "returns a successful response for #{endpoint}" do
    VCR.use_cassette(cassette_name) do
      get endpoint, params: additional_params

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body[data_key]).to eq data_value
    end
  end
end
