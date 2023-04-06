using eCinema.Core;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace eCinema.Infrastructure
{
    public class GenreConfiguration : BaseConfiguration<Genre>
    {
        public override void Configure(EntityTypeBuilder<Genre> builder)
        {
            base.Configure(builder);

            builder.Property(e => e.Name)
                   .IsRequired();
        }
    }
}
