const axios = require('axios');
const sqlite3 = require('sqlite3').verbose();
const db = new sqlite3.Database('./sellvpn.db');

async function createssh(username, password, exp, iplimit, serverId) {
  console.log(`⚙️ Creating SSH for ${username} | Exp: ${exp} | IP Limit: ${iplimit}`);

  if (/\s/.test(username) || /[^a-zA-Z0-9]/.test(username)) {
    return '❌ Username tidak valid.';
  }

  return new Promise((resolve) => {
    db.get('SELECT * FROM Server WHERE id = ?', [serverId], async (err, server) => {
      if (err || !server) return resolve('❌ Server tidak ditemukan.');

      const url = `http://${server.domain}:5888/createssh?user=${username}&password=${password}&exp=${exp}&iplimit=${iplimit}&auth=${server.auth}`;

      try {
        const { data } = await axios.get(url);

        if (data.status !== 'success') return resolve(`❌ Gagal: ${data.message}`);

        const d = data.data;

     // Pesan teks
const messageText = `
🌟 *AKUN SSH PREMIUM* 🌟

┌───☠️───────────────☠️───┐
│ *Username*  : \`${sshData.username}\`
│ *Password*  : \`${sshData.password}\`
└─────💀─────☠️────💀────┘

┌───☠️───────────────☠️───┐
│ *Domain*      : \`${sshData.domain}\`
│ *Port TLS*    : \`443\`
│ *Port HTTP*   : \`80\`
│ *OpenSSH*     : \`22\`
│ *UdpSSH*      : \`1-65535\`
│ *DNS*         : \`443, 53, 22\`
│ *Dropbear*    : \`443, 109\`
│ *SSH WS*      : \`80\`
│ *SSH SSL WS*  : \`443\`
│ *SSL/TLS*     : \`443\`
│ *OVPN SSL*    : \`443\`
│ *OVPN TCP*    : \`1194\`
│ *OVPN UDP*    : \`2200\`
│ *BadVPN UDP*  : \`7100, 7300, 7300\`
└─────💀─────☠️────💀────┘

⚙️ *Petunjuk Singkat*
• Salin credential (username & password) di atas.
• Gunakan port sesuai baris layanan (mis. OpenSSH → 22).
• Untuk bantuan atau konfigurasi, klik tombol di bawah ini.
`;

// Inline button
const replyMarkup = {
  inline_keyboard: [
    [
      { text: "Hubungi Admin", url: "https://t.me/rahmarie" }
    ]
  ]
};

// Contoh pengiriman pakai node-telegram-bot-api
bot.sendMessage(chatId, messageText, {
  parse_mode: "Markdown",
  reply_markup: replyMarkup
});


🔏 *PUBKEY:*
\`\`\`
${d.pubkey}
\`\`\`
📁 *Link Simpan Akun:*
\`\`\`
https://${d.domain}:81/ssh-${d.username}.txt
\`\`\`
📦 *Download OVPN:*
\`https://${d.domain}:81/allovpn.zip\`
┌─────────────────────
│📅 *Expired:* \`${d.expired}\`
│🌐 *IP Limit:* \`${d.ip_limit} IP\`
└─────────────────────
✨ By : *SAGI MARKET VVIP*! ✨
`.trim();

        resolve(msg);
      } catch (e) {
        resolve('❌ Gagal request ke API SSH.');
      }
    });
  });
}

module.exports = { createssh };