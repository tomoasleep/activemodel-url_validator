require 'spec_helper'

# Shared examples for value.

shared_examples_for 'invalid value is given', given: :invalid do
  let(:value) do
    'This is invalid URI'
  end
end

shared_examples_for 'scheme less value is given', given: :scheme_less do
  let(:value) do
    '//example.com/scheme/less'
  end
end

shared_examples_for 'empty string is given', given: :empty do
  let(:value) do
    ''
  end
end

shared_examples_for 'host less value is given', given: :host_less do
  let(:value) do
    'http:///host/less'
  end
end

[:http, :https].each do |scheme|
  shared_examples_for "#{scheme} URI is given", given: scheme do
    let(:value) do
      "#{scheme}://example.com/#{scheme}/scheme"
    end
  end
end

# Shared examples for options

shared_examples_for 'allow_no_scheme is true', allow_no_scheme: true do
  let(:allow_no_scheme) do
    true
  end
end

shared_examples_for 'allow_no_host is true', allow_no_host: true do
  let(:allow_no_host) do
    true
  end
end

shared_examples_for 'scheme includes http', scheme: :http do
  let(:scheme) do
    ['http']
  end
end

shared_examples_for 'scheme is an empty array', scheme: :empty do
  let(:scheme) do
    []
  end
end

describe UrlValidator do
  describe '.valid?' do
    subject do
      described_class.valid?(value, options)
    end

    let(:options) do
      options = {}
      described_class.default_options.keys.each do |option_name|
        options[option_name] = send(option_name) if respond_to? option_name
      end
      options
    end

    context 'when an empty string is given', given: :empty do
      it { should be_falsey }
    end

    context 'when an invalid value is given', given: :invalid do
      it { should be_falsey }
    end

    context 'when a scheme less URI is given', given: :scheme_less do
      it { should be_falsey }

      context 'and scheme less URI is allowed', allow_no_scheme: true do
        it { should be_truthy }

        context 'and scheme option is given', scheme: :http do
          it { should be_truthy }
        end
      end
    end

    context 'when a host less URI is given', given: :host_less do
      it { should be_falsey }

      context 'and host less URI is allowed', allow_no_host: true do
        it { should be_truthy }
      end
    end

    context 'when a HTTP URI is given', given: :http do
      it { should be_truthy }

      context 'and http scheme is allowed', scheme: :http do
        it { should be_truthy }
      end

      context 'and http scheme is not allowed', scheme: :empty do
        it { should be_falsey }
      end
    end

    context 'when a HTTPS URI is given', given: :https do
      it { should be_truthy }

      context "and http scheme is allowed but https isn't", scheme: :http do
        it { should be_falsey }
      end
    end
  end

  describe 'validation' do
    subject do
      model_class.new(attr: value)
    end

    context 'when custom option is not specified' do
      let(:model_class) do
        Class.new(TestModel) do
          validates :attr, url: true
        end
      end

      context 'and a valid scheme less value is given', given: :scheme_less do
        it { should be_invalid }
      end

      context 'and a valid host less value is given', given: :host_less do
        it { should be_invalid }
      end

      context 'and an empty string is given', given: :empty do
        it { should be_invalid }
      end

      context 'and a valid http value is given', given: :http do
        it { should be_valid }
      end

      context 'and an invalid value is given', given: :invalid do
        it { should be_invalid }
      end
    end

    context 'when allow_no_scheme is true' do
      let(:model_class) do
        Class.new(TestModel) do
          validates :attr, url: { allow_no_scheme: true }
        end
      end

      context 'and a valid scheme less value is given', given: :scheme_less do
        it { should be_valid }
      end
    end

    context 'when allow_no_host is true' do
      let(:model_class) do
        Class.new(TestModel) do
          validates :attr, url: { allow_no_host: true }
        end
      end

      context 'and a valid host less value is given', given: :host_less do
        it { should be_valid }
      end
    end

    context 'when http scheme is allowed', scheme: :http do
      let(:model_class) do
        Class.new(TestModel) do
          validates :attr, url: { scheme: ['http'] }
        end
      end

      context 'and a valid scheme less value is given', given: :scheme_less do
        it { should be_invalid }
      end

      context 'and a valid http value is given', given: :http do
        it { should be_valid }
      end

      context 'and a valid https value is given', given: :https do
        it { should be_invalid }
      end
    end
  end
end
