require 'test_helper'

describe CfScript::Output::Tests do
  include MockExecution

  it "defines matches? and calls the out buffer matches?" do
    output = fake_output

    output.out.stub :matches?, 'called' do
      assert_equal 'called', output.matches?('a')
    end
  end

  it "defines contains? and calls the out buffer matches?" do
    output = fake_output

    output.out.stub :contains?, 'called' do
      assert_equal 'called', output.contains?('a')
    end
  end

  it "defines ok?, calls the out buffer last_line_matches?" do
    output = fake_output('OK')

    assert output.ok?
    refute fake_output('KO').ok?
  end

  it "defines authenticated? and calls matches?" do
    output = fake_output("Authenticating...\nOK")

    assert output.authenticated?
    refute fake_output('NOPE').authenticated?
  end

  it "defines failed? and calls contains?" do
    output = fake_output("FAILED")

    assert output.failed?
    refute fake_output('OK').failed?
  end

  it "defines no_api_endpoint? and calls contains?" do
    output = fake_output("No API endpoint set.")

    assert output.no_api_endpoint?
    refute fake_output('API endpoint set').no_api_endpoint?
  end

  it "defines not_logged_in? and calls contains?" do
    output = fake_output("Not logged in")

    assert output.not_logged_in?
    refute fake_output('logged in').not_logged_in?
  end

  it "defines not_authorized? and calls contains?" do
    output = fake_output("You are not authorized")

    assert output.not_authorized?
    refute fake_output('You are authorized').not_authorized?
  end

  it "defines credentials_rejected? and calls contains?" do
    output = fake_output("Credentials were rejected")

    assert output.credentials_rejected?
    refute fake_output('Credentials accepted').credentials_rejected?
  end

  it "defines not_found? and calls out buffer's last_line_matches?" do
    output = fake_output("App api not found")

    assert output.not_found?('App', 'api')
    refute fake_output('Found').not_found?('App', 'api')
  end

  it "defines is_already? and calls out buffer's last_line_matches?" do
    output = fake_output("app is already started")

    assert output.is_already?('app', 'started')
    refute fake_output('app not started').is_already?('app', 'started')
  end

  it "defines already_exists? and calls out buffer's last_line_matches?" do
    output = fake_output("App api already exists")

    assert output.already_exists?('App', 'api')
    refute fake_output('App api does not exist').already_exists?('App', 'api')
  end
end
