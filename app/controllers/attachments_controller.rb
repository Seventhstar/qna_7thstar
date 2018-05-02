class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_attachment

  authorize_resource

  respond_to :json
  def destroy
    respond_with(@attachment.destroy)
  end

private

  def load_attachment
    @attachment = Attachment.find(params[:id])
  end

  def attachment_params
    params.require(:attachment).permit(:id)
  end
end
