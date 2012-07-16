require "spec_helper"

describe Ringleader::Config do

  context "when initialized with a config file" do
    subject { Ringleader::Config.new "spec/fixtures/config.yml" }

    describe "#apps" do
      it "returns a list of app configs" do
        expect(subject.apps).to have(3).entries
      end

      it "returns a hash of configurations" do
        config = subject.apps["main_site"]
        expect(config.dir).to eq("~/apps/main")
      end

      it "includes a default hostname" do
        expect(subject.apps["admin"].hostname).to eq("127.0.0.1")
      end

      it "includes a default idle timeout" do
        expect(subject.apps["admin"].idle_timeout).to eq(0)
      end

      it "sets the config name to match the key in the config file" do
        expect(subject.apps["admin"].name).to eq("admin")
      end
    end
  end

  context "when initialized with an invalid config" do
    subject { Ringleader::Config.new "spec/fixtures/invalid.yml" }

    it "raises an exception" do
      expect { subject.apps }.to raise_error(/command.*missing/i)
    end
  end

end