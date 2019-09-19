class FellRace.Views.MyEntry extends FellRace.View
  template: 'entries/my_entry'

  bindings:
    ".race_name": "race_name"
    ".instance_name": "instance_name"

    "a.entry_list":
      attributes: [
        name: "href"
        observe: ["race_slug","instance_name"]
        onGet: "instanceUrl"
      ]

    "a.close, a.race_name":
      attributes: [
        name: "href"
        observe: "race_slug"
        onGet: "racePublicationUrl"
      ]

  onRender: () =>
    @stickit()

  racePublicationUrl: (slug) =>
    "/races/#{slug}"

  instanceUrl: ([slug,name]=[]) =>
    "/races/#{slug}/#{name}"
