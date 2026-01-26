/*
Short version: **`Substring` is a view into a `String`, not a copy**.

Let’s break it down cleanly.

---

## 1️⃣ What is `String`?

* Owns its **own storage**
* Value type (copy-on-write)
* Safe to store long-term
* Heavier in memory

```swift
let str: String = "Hello, Swift"
```

Use `String` when:

* You store text in variables / properties
* You return text from functions
* You keep text beyond a local scope

---

## 2️⃣ What is `Substring`?

* **Slice / view** of an existing `String`
* Shares the **same memory buffer**
* Very cheap to create
* **Keeps the entire original string alive** 😬

```swift
let s = "Hello, Swift"
let sub = s.prefix(5)   // Substring
print(sub)              // "Hello"
```

👉 Even though `sub` is just `"Hello"`, Swift keeps `"Hello, Swift"` in memory.

---

## 3️⃣ Why does Swift have `Substring`?

### Performance 🚀

Creating substrings is **O(1)** (no copy):

```swift
let sub = s[s.startIndex..<s.index(s.startIndex, offsetBy: 5)]
```

If this returned a `String`, Swift would have to copy every time.

---

## 4️⃣ The hidden danger ⚠️

This is BAD:

```swift
let hugeText = loadBigFile()
let small = hugeText.prefix(10)   // Substring
// hugeText cannot be freed!
```

Even if you only need 10 characters, the **entire file stays in memory**.

---

## 5️⃣ Converting `Substring → String` (important!)

Do this when:

* Storing substrings
* Returning them from functions
* Keeping them beyond a short scope

```swift
let sub = s.prefix(5)
let safeString = String(sub)   // copies only needed part
```

✅ Now only `"Hello"` is stored.

---

## 6️⃣ Common APIs return `Substring`

| API            | Return type   |
| -------------- | ------------- |
| `prefix()`     | `Substring`   |
| `suffix()`     | `Substring`   |
| `split()`      | `[Substring]` |
| String slicing | `Substring`   |

Example:

```swift
let words = "one two three".split(separator: " ")
// [Substring]
```

Convert if needed:

```swift
let strings = words.map(String.init)
```

---

## 7️⃣ Quick rule of thumb 🧠

✔ Use `Substring`

* Temporarily
* Inside a function
* For quick parsing

✔ Convert to `String`

* Before storing
* Before returning
* If original string is large

---

### One-liner memory rule

> **If a substring escapes the current scope → make it a `String`.**


*/
