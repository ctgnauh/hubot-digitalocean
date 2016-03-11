# Description
#   A hubot script to manager DigitalOcean VPS
#
# Configuration:
#   DO_TOKEN - DigitalOcean API TOKEN
#
# Commands:
#   hubot do list - show all droplets
#   hubot do reboot <droplets-id> - reboot droplets
#   hubot do shutdown <droplets-id> - shutdown droplets
#   hubot do on <droplets-id> - power on droplets
#   hubot do off <droplets-id> - power off droplets
#   hubot do cycle <droplets-id> - power cycle droplets
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
  robot.respond /do\s+(\w+)(?:\s+(\w+))?/, (res) ->

    exec = {
      list: () ->
        api.droplets.list().do (err, data) ->
          if err
            console.error err
            res.reply "there has something wrong"
          else
            res.send "search droplets..."
            lines = []
            data.droplets.forEach (t, i, a) ->
              lines.push "#{t.name} (#{t.id}): #{t.image.slug} / #{t.size_slug} Memory / #{t.disk}GB Disk / #{t.region.slug}, #{t.status}"
            res.reply lines.join "\n"

      reboot: (id) ->
        api.droplets.reboot(id).do (err, data) ->
          res.reply "in-process"

      shutdown: (id) ->
        api.droplets.shutdown(id).do (err, data) ->
          res.reply "in-process"

      on: (id) ->
        api.droplets.power_on(id).do (err, data) ->
          res.reply "in-process"

      off: (id) ->
        api.droplets.power_off(id).do (err, data) ->
          res.reply "in-process"

      cycle: (id) ->
        api.droplets.power_cycle(id).do (err, data) ->
          res.reply "in-process"
    }

    subcmd = res.match[1]
    arg = res.match[2]

    if subcmd in cmds
      exec[subcmd](arg)
    else
      res.reply "command does not exist"
