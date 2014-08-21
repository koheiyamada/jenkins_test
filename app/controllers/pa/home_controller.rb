class Pa::HomeController < UserHomeController
  include ParentAccessControl
  parent_only
end
