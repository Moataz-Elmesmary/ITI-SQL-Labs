# ITI SQL Labs - Complete Solutions <img src="https://upload.wikimedia.org/wikipedia/commons/8/87/Sql_data_base_with_logo.png" width="40" alt="SQL Logo"/> 

<img src="https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExcW0yY2VlZ3FqY2JjY3B6eG5jZ2Z4dWZ6eGQ2a2RjbjB1dGZ6eWZ6YiZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/13HgwGsXF0aiGY/giphy.gif" width="200" align="right" alt="Database Gif">

<table align="right">
  <tr>
    <td>
      <img src="https://github.com/user-attachments/assets/243c5c7d-3d39-48f1-b54c-77659bd80f25" alt="ITI Logo" height="100">
    </td>
  </tr>
</table>

## 📋 Repository Description  
ITI DB-SQL Labs Answers by me, featuring:

- **Lab Folders**: Each lab is organized into its own folder, containing:
- **SQL Scripts**: Detailed solutions for each lab exercise.
- **Backup Files**: .bak files for restoring the database state pertinent to each lab.
- **Resources**: Additional materials to supplement your learning.

---

## 📚 Notes & Links helped me revising and remembering:

<table>
  <tr>
    <td width="30%"><b>Based On Lectures</b></td>
    <td>
      <ul>
        <li><a href="https://drive.google.com/drive/folders/1PvaQay1-cddCIegXObp5X5DW8cXpCo85">Lectures Best Notes</a></li>
        <li><a href="https://www.youtube.com/playlist?list=PLAowHBw9BCw5b56-SfY7tgndHbGcQycp2">Lectures Playlist (By Eng.Rami)</a></li>
      </ul>
    </td>
  </tr>
  <tr>
    <td><b>Helpful Notes</b></td>
    <td>
      <ul>
        <li><a href="https://relic-dimple-eee.notion.site/SQL-c11692abdd894c89ab73d82545db0e63">Notes by Mariem Abdalwahab</a></li>
        <li><a href="https://well-stoat-3a6.notion.site/SQL-3121837d8bb24c798a20057b43cc3307">Notes by Mohamed Mattar</a></li>
      </ul>
    </td>
  </tr>
</table>

---

## 🚀 Full Power BI Track Materials


<div align="center">
  <a href="https://github.com/Moataz-Elmesmary/ITI-Business-Intelligence-Development">
    <img src="https://img.shields.io/badge/_My_BI_Repository-Important-blue?style=for-the-badge&logo=github">
  </a> <img src="https://media.giphy.com/media/mBYkXvLxkHZFmqBHIC/giphy.gif" width=50px height=40px>
  <br>
  <em>Complete collection of BI track materials, projects, and resources.</em>
</div>

<details>
<summary>💡 Database Tip</summary>
  

<h5>Pro Tip: Always BACKUP before you ALTER!</h5>

| Situation                  | Backup Type       | Risk Level |
|----------------------------|-------------------|------------|
| Before ALTER TABLE          | Full DB           | ☠️☠️☠️☠️☠️ |
| Before running DELETE       | Transaction Log   | ☠️☠️☠️     |
| Before Power BI refresh     | .pbix File        | ☠️☠️☠️☠️   |
| Before Projects submission   | Both .bak and .sql| ☠️☠️☠️☠️☠️ |
---
</details>

<details>
<summary><strong>🧼 Writing Clean SQL</strong> – Make your queries readable</summary>

<blockquote>
“Good code is its own best documentation.” – Steve McConnell</blockquote>
</blockquote>

### ❌ Before (Spaghetti Code)
```sql
select c.customer_id,c.first_name,c.last_name,o.order_id,o.order_date 
from customers c 
join orders o on c.customer_id=o.customer_id 
where c.country='germany' AND o.quantity>100
```

### ✅ After (Clean & Readable)
```sql
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    o.order_id,
    o.order_date
FROM customers c
INNER JOIN orders o
    ON c.customer_id = o.customer_id
WHERE c.country = 'Germany'
    AND o.quantity > 100;
```
