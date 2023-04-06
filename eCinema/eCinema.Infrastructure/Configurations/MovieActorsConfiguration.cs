using eCinema.Core;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace eCinema.Infrastructure
{
    public class MovieActorsConfiguration : BaseConfiguration<MovieActors>
    {
        public override void Configure(EntityTypeBuilder<MovieActors> builder)
        {
            base.Configure(builder);

            builder.HasOne(e => e.Movie)
                 .WithMany(e => e.MovieActors)
                 .HasForeignKey(e => e.MovieId)
                 .IsRequired();

            builder.HasOne(e => e.Actors)
                   .WithMany(e => e.MovieActors)
                   .HasForeignKey(e => e.ActorId)
                   .IsRequired();
        }
    }
}
