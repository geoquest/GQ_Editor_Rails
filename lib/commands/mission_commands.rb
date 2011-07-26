require 'commands/command'
require 'missions/all_mission_operations'

ERB.new <<-EOF
      <mission type="WebPage"
         id="<%= id %>"
         name="WebPage_<%= id %>"
         url="http://www.example.com"
         cancel="success">
</mission>
EOF




class AddSubmissionCommand < Command
  def initialize(params)
    super(params)
    @type = "AddSubmissionCommand"

    id = params["submission_id"]

    manager = AllMissionOperations.new()
    template = manager.get_mission_type_template(params["submission_type"])
    node = template.result(binding)

    template = ERB.new <<-EOF
let $newMission := <%= node %>
let $parentMission := doc("game.xml")//mission[@id="<%= params["mission_id"] %>"]
return update insert $newMission into $parentMission
EOF

    @command = template.result(binding)

  end

end

class AddMissionCommand < Command
  def initialize(params)
    super(params)
    @type = "AddMissionCommand"

    id = params["new_mission_id"]

    manager = AllMissionOperations.new()
    template = manager.get_mission_type_template(params["new_mission_type"])
    node = template.result(binding)

    template = ERB.new <<-EOF
let $newMission := <%= node %>
return update insert $newMission into doc("game.xml")/game
EOF

    @command = template.result(binding)

  end

end


class DeleteMissionCommand < Command
  def initialize(params)
    super(params)
    @type = "DeleteMissionCommand"


    template = ERB.new <<-EOF
let $mission := doc("game.xml")//mission[@id="<%= params["mission_id"] %>"]
return update delete $mission
EOF

    @command = template.result(binding)

  end

end