module HasRateLimits
  extend ActiveSupport::Concern

  # TODO: Adjust for NADA needs

  WINDOW = 900
  REQUESTS_ALLOWED = 500
  COOLDOWN = 300
end
