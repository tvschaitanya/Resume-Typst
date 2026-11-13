
#import "@preview/basic-resume:0.2.9": *
#import "contact.typ": *
#import "data.typ": *


// ── Section Order ─────────────────────────────────────────────────────────────
// Rearrange sections or comment out a section to hide it.

#let section-order = (
  "summary",
  "skills",
  "experience",
  "projects",
  "education",
  "certifications",
)


// ── Helper ────────────────────────────────────────────────────────────────────
// Treat empty or missing values as none.

#let maybe(s) = if s == none or s == "" { none } else { s }


// ── Resume Settings ───────────────────────────────────────────────────────────
// Name: 16pt | All other text: 10pt

#set text(size: 10pt)

#show: resume.with(
  author:                 upper(name),
  author-font-size:       16pt,
  location:               maybe(location),
  email:                  maybe(email),
  github:                 maybe(github),
  linkedin:               maybe(linkedin),
  phone:                  maybe(phone),
  ..if maybe(personal-site) != none { (personal-site: personal-site) },
  accent-color:           "#000000",
  font:                   "Times New Roman",
  paper:                  "us-letter",
  author-position:        center,
  personal-info-position: center,
)


// ── Section Renderer ──────────────────────────────────────────────────────────
// Display each section only when it contains data.

#let render-section(s) = {

  // Summary
  if s == "summary" {
    if summary != "" [
      == Summary
      #summary
    ]

  // Skills
  } else if s == "skills" {
    if skills.len() > 0 [
      == Skills
      #for s in skills [
        - *#s.label*: #s.items
      ]
    ]

  // Work Experience
  } else if s == "experience" {
    if work-experience.len() > 0 [
      == Experience
      #for w in work-experience [
        #show list: set block(above: 6pt)

        #block(below: 6pt, grid(
          columns: (1fr, auto),
          column-gutter: 1em,
          align: (left, right),
          [#strong(w.title)#if maybe(w.company) != none [ | #w.company]#if maybe(w.location) != none [#if maybe(w.company) != none [, ] else [ | ]#w.location]],
          dates-helper(start-date: w.start, end-date: w.end),
        ))

        #for b in w.bullets [- #eval(b, mode: "markup")]
        #if w.bullets.len() == 0 [ #v(2pt) ]
      ]
    ]

  // Projects
  } else if s == "projects" {
    if projects.len() > 0 [
      == Projects
      #for p in projects [
        #show list: set block(above: 6pt)

        #block(below: 6pt, grid(
          columns: (1fr, auto),
          column-gutter: 1em,
          align: (left, right),
          [#strong(p.name)#if maybe(p.role) != none [ | #p.role]],
          [#if maybe(p.url) != none { link(if p.url.starts-with("https://") or p.url.starts-with("http://") { p.url } else { "https://" + p.url })[ #p.url ] }],
        ))

        #for b in p.bullets [- #eval(b, mode: "markup")]
        #if p.bullets.len() == 0 [ #v(2pt) ]
      ]
    ]

  // Education
  } else if s == "education" {
    if education.len() > 0 [
      == Education
      #for e in education [
        #edu(
          institution: e.institution,
          location:    maybe(e.location),
          dates:       dates-helper(start-date: e.start, end-date: e.end),
          degree:      maybe(eval(e.degree, mode: "markup")),
        )

        #for b in e.bullets [- #eval(b, mode: "markup")]
        #if e.bullets.len() == 0 [ #v(2pt) ]
      ]
    ]

  // Certifications
  } else if s == "certifications" {
    if certifications.len() > 0 [
      == Certifications
      #for c in certifications [
        - #c.name
      ]
    ]
  }
}


// ── Render Resume ─────────────────────────────────────────────────────────────
// Render sections in the order defined above.

#for s in section-order {
  render-section(s)
}
