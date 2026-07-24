const http = require('http')
const fs = require('fs')
const path = require('path')

const PORT = 3000

const MIME_TYPES = {
  '.html': 'text/html; charset=utf-8',
  '.js': 'application/javascript',
  '.css': 'text/css',
  '.json': 'application/json',
  '.png': 'image/png',
  '.jpg': 'image/jpeg',
  '.svg': 'image/svg+xml',
}

const server = http.createServer((req, res) => {
  let filePath = path.join(__dirname, req.url === '/' ? 'index.html' : req.url)
  const ext = path.extname(filePath)

  fs.readFile(filePath, (err, content) => {
    if (err) {
      if (err.code === 'ENOENT') {
        fs.readFile(path.join(__dirname, 'index.html'), (err2, content2) => {
          res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' })
          res.end(content2, 'utf-8')
        })
      } else {
        res.writeHead(500)
        res.end('Server Error')
      }
    } else {
      res.writeHead(200, { 'Content-Type': MIME_TYPES[ext] || 'text/plain' })
      res.end(content, 'utf-8')
    }
  })
})

server.listen(PORT, () => {
  console.log(`\n  🌐 Alhadel Net يعمل على:`)
  console.log(`  http://localhost:${PORT}\n`)
})