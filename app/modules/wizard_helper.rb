# coding: utf-8

# Wickedを使ったウィザード形式のフォームのサポート

module WizardHelper
  class WizardSession
    def update_step(step)
      @current_step = step
    end

    def check_step(step)
      @current_step == step
    end

    attr_reader :current_step
  end

  def init_session
    session[wizard_session_key] = WizardSession.new
  end

  def clear_session
    session[wizard_session_key] = nil
  end

  def check_session
    if session[wizard_session_key]
      if request.get?
        session[wizard_session_key].update_step step
      else
        unless session[wizard_session_key].check_step step
          on_wizard_session_inconsistent
        end
      end
    else
      on_wizard_session_empty
    end
  end

  private

    def on_wizard_session_inconsistent
      # do nothing
    end

    def on_wizard_session_empty
      # do nothing
    end

    def wizard_session_key
      :wizard_session_key
    end
end