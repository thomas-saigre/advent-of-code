🐴📁 = "input.txt";
🌀 = Int;✂️ = parse;📇 = readlines;🖨️ = println;⛰️ = maximum;🪨 = floor;👻 = 2503;📥 = zeros;📏 = length;🔍 = findall;⚽ = match

function ✏(🚦)
🏠, 🕦, 🐦, 😴 = ⚽(r"(\w+) can fly (\d+) km/s for (\d+) seconds, but then must rest for (\d+) seconds.", 🚦).captures
return 🏠, ✂️(🌀, 🕦), ✂️(🌀, 🐦), ✂️(🌀, 😴)
end

function ✂️✂️(🐴📄) 📄 = open(🐴📄);🚦🚦 = 📇(📄); close(📄); return ✏.(🚦🚦) end

function 📍(🐴, 🕐) 🐦 = 🐴[2]; 🕦 = 🐴[3]; 😴 = 🐴[4]; *️⃣ = 🪨(🌀, 🕐 / (🕦 + 😴))
⏰ = 🕐 - *️⃣ * (🕦 + 😴); 🏃 = *️⃣ * 🕦 * 🐦; if ⏰ <= 🕦 🏃 += ⏰ * 🐦 else 🏃 += 🕦 * 🐦 end; return 🏃 end

function 🚲(🐴🐴, 🕐)
💯 = 📥(🌀, 📏(🐴🐴)); for ⌛ in 1:🕐; 🏃 = 📍.(🐴🐴, ⌛); ⛰️⛰️ = ⛰️(🏃); 🕯️ = 🔍(🏃 .== ⛰️⛰️); 💯[🕯️] .+= 1 end; return ⛰️(💯) end

🔥 = ✂️✂️(🐴📁)
🏃 = 📍.(🔥, 👻)
🖨️(⛰️(🏃))
🖨️(🚲(🔥, 👻))