# activemodel-url_validator

[![Build Status](https://travis-ci.org/increments/activemodel-url_validator.svg?branch=master)](https://travis-ci.org/increments/activemodel-url_validator)

## Usage

Add to your Gemfile:

```rb
gem 'activemodel-url_validator'
```

Run:

```
bundle install
```

Then add the following to your model:

```rb
validates :my_url_attribute, url: true
```

### Custom options

Name | Value | Default | Desc.
----|----|----|----
`scheme` | Array of String | nil | Specify allowed scheme types.
`allow_no_scheme` | Boolean | false | Whether scheme less URI is allowed.
`allow_no_host` | Boolean | false | Whether host less URI is allowed.

```rb
validates :my_url_attribute, url: { scheme: ['https'] }
```

## Validation outside a model

If you need to validate a url outside a model, you can do that:

```rb
UrlValidator.valid?(string, options)
```
