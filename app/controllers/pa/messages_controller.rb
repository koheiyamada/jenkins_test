class Pa::MessagesController < MessagesController
  include ParentAccessControl
  parent_only
end
