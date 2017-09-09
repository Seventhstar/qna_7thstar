module VotesHelper

  def vote_link(id, text, val, type, visible )
    data = { votable_id: id, votable_type: type }
    data[:value] = val if !val.nil?
    cls = val.nil? ? 'reset-vote-link' : 'vote-link'
    link_to text, '#', class: cls, data: data , style: "display: #{ visible ? '' : 'none' }"
  end    

end
