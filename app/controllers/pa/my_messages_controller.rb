class Pa::MyMessagesController < MyMessagesController
  include ParentAccessControl
  parent_only
end
