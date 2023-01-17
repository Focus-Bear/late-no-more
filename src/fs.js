const fs = require('fs')
const path = require('path')
const { stringify } = require('csv-stringify/sync')
const { parse } = require('csv-parse/sync')
const home = require('os').homedir()

const csvPath = home + '/Documents/LateNoMore-Meetings.csv'

async function ensure() {
    try {
        const raw = fs.readFileSync(csvPath),
            data = parse(raw, {
                columns: [
                    'date',
                    'id',
                    'summary',
                    'intention',
                    'notes',
                    'success',
                ],
            })
        return data.slice(1)
    } catch (e) {
        console.log(e)
        fs.writeFileSync(csvPath, '[]', { flag: 'w' })
        return []
    }
}

async function save(data) {
    try {
        const asString = stringify(data, {
            header: true,
            columns: ['date', 'id', 'summary', 'intention', 'notes', 'success'],
            cast: { date: (d) => d.toISOString() },
        })
        fs.writeFileSync(csvPath, asString, { flag: 'w' })
        console.log('Saved', csvPath)
    } catch (e) {
        console.log(e)
    }
}

async function update(row) {
    const records = await ensure(csvPath)
    if (!records?.length) {
        await save([row])
        return
    }
    try {
        const final = records.map((r) => {
            if (row.id !== r.id) return r
            const updated = { ...r }
            for (const key in row) {
                const value = row[key]
                updated[key] = value
            }
            return updated
        })

        await save(final)
    } catch (e) {
        console.log(e)
    }
}

const row = { summary: 'Event', date: new Date(), intention: 'hi' }

module.exports = { save, ensure, parse, update }
