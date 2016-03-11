# Description
#   A hubot script to manager DigitalOcean VPS
#
# Configuration:
#   DO_TOKEN - DigitalOcean API TOKEN
#
# Commands:
#   do list - show all droplets
#   do reboot <droplets_id> - reboot droplets
#   do shutdown <droplets_id> - shutdown droplets
#   do on <droplets_id> - power on droplets
#   do off <droplets_id> - power off droplets
#   do cycle <droplets_id> - power cycle droplets
#
# Notes:
#   This is an experimental script.
#
# Author:
#   ctgnauh <huangtc@outlook.com>

Do = require "digio-api"

api = new Do process.env.DO_TOKEN

cmds = ["list", "reboot", "shutdown", "on", "off", "cycle"]

module.exports = (robot) ->
  robot.hear /do\s+(\w+)(?:\s+(\w+))?/, (res) ->

    exec = {
      list: () ->
        api.droplets.list().do (err, data) ->
          if err
            console.error err
            res.send "there has something wrong"
          else
            res.send "search droplets..."
            lines = []
            data.droplets.forEach (t, i, a) ->
              lines.push "#{t.name} (#{t.id}): #{t.image.slug} / #{t.size_slug} Memory / #{t.disk}GB Disk / #{t.region.slug}, #{t.status}"
            res.send lines.join "\n"

      reboot: (id) ->
        api.droplets.reboot(id).do (err, data) ->
          res.send "in-process"

      shutdown: (id) ->
        api.droplets.shutdown(id).do (err, data) ->
          res.send "in-process"

      on: (id) ->
        api.droplets.power_on(id).do (err, data) ->
          res.send "in-process"

      off: (id) ->
        api.droplets.power_off(id).do (err, data) ->
          res.send "in-process"

      cycle: (id) ->
        api.droplets.power_cycle(id).do (err, data) ->
          res.send "in-process"
    }

    subcmd = res.match[1]
    arg = res.match[2]

    if subcmd in cmds
      exec[subcmd](arg)
    else
      res.send "command does not exist"
