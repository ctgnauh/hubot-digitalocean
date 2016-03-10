# Description
#   A hubot script to manager DigitalOcean VPS
#
# Configuration:
#   DO_TOKEN - DigitalOcean API TOKEN
#
# Commands:
#   hubot do list - show all droplets
#   hubot do reboot <droplets_id> - reboot droplets
#   hubot do shutdown <droplets_id> - shutdown droplets
#   hubot do on <droplets_id> - power on droplets
#   hubot do off <droplets_id> - power off droplets
#   hubot do cycle <droplets_id> - power cycle droplets
#
# Notes:
#   This is an experimental script.
#
# Author:
#   ctgnauh <huangtc@outlook.com>

Do = require "digio-api"
Table = require "cli-table"

api = new Do process.env.DO_TOKEN

cmds = ["list", "reboot", "shutdown", "on", "off", "cycle"]

module.exports = (robot) ->
  robot.respond /do\s+(\w+)(?:\s+(\w+))?/, (res) ->

    exec = {
      list: () ->
        api.droplets.list().do (err, data) ->
          if err
            console.error err
            res.send "there has something wrong"
          table = new Table {
            head: ['id', 'name', 'cpu', 'mem', 'disk', 'region', 'status']
          }
          data.droplets.forEach (t, i, a) ->
            table.push [t.id, t.name, t.vcpus, t.memory, t.disk, t.region.slug, t.status]
          res.send table.toString()

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
