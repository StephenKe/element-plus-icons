const fs = require('fs')
const { constants } = fs

fs.access('./icons-vue', constants.F_OK, (err) => {
  // console.log(err)
  if (err) fs.mkdirSync('./icons-vue')
  fs.copyFile('./LICENSE', './icons-vue/LICENSE', (err) => {
    // console.log('----', err)
  })
  fs.copyFile(
    './packages/vue/package.json',
    './icons-vue/package.json',
    (err) => {
      // console.log('~~~~', err)
    }
  )
  fs.cp(
    './packages/vue/dist/',
    './icons-vue/dist/',
    { recursive: true },
    (err) => {
      // console.log('~~~~', err)
    }
  )
})
