using eCinema.Core;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace eCinema.Infrastructure
{
    public class ProductionConfiguration : BaseConfiguration<Production>
    {
        public override void Configure(EntityTypeBuilder<Production> builder)
        {
            base.Configure(builder);

            builder.Property(e => e.Name)
                 .IsRequired();

            builder.HasOne(e => e.Country)
                   .WithMany(e => e.Productions)
                   .HasForeignKey(e => e.CountryId)
                   .IsRequired();
        }
    }
}
