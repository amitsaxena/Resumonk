class Experience < ActiveRecord::Base
  belongs_to :resume
  validates :company_name, :designation, :job_description, presence: true

  default_scope order('position asc')
end
