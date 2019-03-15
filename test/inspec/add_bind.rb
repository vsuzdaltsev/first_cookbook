my_bind_file_from_attrs='
node1.ololo.net                        IN         mx         20             10.7.1.1
node2.ololo.net                        IN         mx         20             10.7.1.2
node3.ololo.net                        IN         mx         20             10.7.1.3
node4.ololo.net                        IN         mx         20             10.7.1.4
node5.ololo.net                        IN         mx         20             10.7.1.5
node6.ololo.net                        IN         mx         20             10.7.1.6
node7.ololo.net                        IN         mx         20             10.7.1.7
node8.ololo.net                        IN         mx         20             10.7.1.8
node9.ololo.net                        IN         mx         20             10.7.1.9
node10.ololo.net                       IN         mx         20            10.7.1.10
'

describe file('/tmp/my_bind_file_from_attrs') do
  its('content') { should match(/#{my_bind_file_from_attrs}/) }
end
