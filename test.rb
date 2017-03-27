require 'yesgraph'
require 'json'

yg = Yesgraph::YesGraphAPI.new(SECRET_KEY)

entries = [
    {'name'=> 'Ivan Kirigin', 'email'=> 'ivan@yesgraph.com'},
    {'name'=> 'Bar', 'email'=> 'bar@example.org'}
]

res = yg.post_address_book(1, entries, 'gmail', source_name: 'Mayank Juneja', source_email: 'mayank@yesgraph.com')
puts JSON.pretty_generate(res)
puts('===')

res=yg.post_address_book(1, entries, 'gmail', source_name: 'Mayank Juneja', source_email: 'mayank@yesgraph.com', backfill: 1)
puts JSON.pretty_generate(res)
puts('===')

res = yg.get_address_book(1 )
puts JSON.pretty_generate(res)
puts('===')

# res = yg.delete_address_book(1 )
# puts JSON.pretty_generate(res)
# puts('===')

entries = [
    {
        'user_id'=> '1111',
        'invitee_name'=> 'Carolyn',
        'email'=> 'carolyn@yesgraph.com',
        'phone'=> '2223332222',
        'sent_at'=> '2017-02-28T20:16:12+00:00'
    }
]

res = yg.post_invites_sent(entries)
puts JSON.pretty_generate(res)
puts('===')


entries = [{'new_user_id'=> '1111',
            'name':'Carolyn',
            'email':'carolyn@yesgraph.com',
            'phone'=> '4442223333',
            'accepted_at'=> '2017-02-28T20:16:12+00:00'
           }]

res = yg.post_invites_accepted(entries)
puts JSON.pretty_generate(res)
puts('===')

entries = [{'user_id'=> '1111',
            'name':'Carolyn',
            'emails'=> ['carolyn@yesgraph.com'],
            'seen_at'=> '2017-02-28T20:16:12+00:00'
           }]

res = yg.post_suggested_seen(entries)
puts JSON.pretty_generate(res)
puts('===')


users = [
    {
        'username'=> 'mayank',
        'name'=> 'Mayank Juneja',
        'email'=> 'mayank@yesgraph.com'
    },
    {
        'id'=> '1234',
        'email'=> 'ivan@yesgraph.com'
    }
]

res = yg.post_users(users)
puts JSON.pretty_generate(res)
puts('===')

res = yg.get_domain_emails('yesgraph.com')
puts JSON.pretty_generate(res)
puts('===')
