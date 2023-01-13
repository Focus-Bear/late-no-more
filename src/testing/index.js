const { setUpcoming, upcomingEvents } = require("../upcoming.js");

const { LOOK_AHEAD_MINUTES } = require("../../config.js");

function addDummyEvent(summary, uid, offset, location, url, description) {
  const startDate = new Date();
  startDate.setMinutes(startDate.getMinutes() + offset);

  const evt = { summary, startDate, uid, location, url, description };
  setUpcoming([...upcomingEvents, evt]);
  console.log("Adding entry to upcomingEvents..");
}

module.exports = async function addTestEvents() {
  console.log("In testing mode...");

  const waitFor = LOOK_AHEAD_MINUTES - 0.5;
 addDummyEvent("Event", "1", waitFor, "meeting room", "https://google.com");
 // addDummyEvent("Event", "1", 15.25, "meeting room", "https://google.com");
};
