module VotesHelper

  def vote_link(obj, text, val, visible )
    data = { votable_id: obj.id, votable_type: obj.class.name, remote: true, method: :post, type: :json }
    cls = val.nil? ? 'reset-vote-link' : 'vote-link'
    lnk = val.nil? ? :reset : "vote_#{text.downcase}"
    link_to text, polymorphic_path([lnk,obj]), class: cls, style: "display: #{ visible ? '' : 'none' }", data: data
  end    

end
