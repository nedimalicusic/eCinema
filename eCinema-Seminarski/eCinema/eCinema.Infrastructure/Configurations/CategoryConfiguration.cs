using eCinema.Core.Entities;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace eCinema.Infrastructure.Configurations
{
    public class CategoryConfiguration : BaseConfiguration<Category>
    {
        public override void Configure(EntityTypeBuilder<Category> builder)
        {
            base.Configure(builder);

            builder.Property(c => c.Name)
              .IsRequired();

            builder.Property(c => c.IsDisplayed)
             .IsRequired();
        }
    }
}
