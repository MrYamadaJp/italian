package beans;

public class Dish {
    private int id;
    private String name;
    private String description;
    private int price;
    private int categoryId;
    private boolean active;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public int getPrice() { return price; }
    public void setPrice(int price) { this.price = price; }
    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }
    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }
}

