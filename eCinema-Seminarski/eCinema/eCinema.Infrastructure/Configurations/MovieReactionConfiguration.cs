using eCinema.Core;
using Microsoft.EntityFrameworkCore.Metadata.Builders;


namespace eCinema.Infrastructure.Configurations
{
    public class MovieReactionConfiguration : BaseConfiguration<MovieReaction>
    {
        public override void Configure(EntityTypeBuilder<MovieReaction> builder)
        {
            base.Configure(builder);

            builder.HasOne(e => e.Movie)
               .WithMany(e => e.MovieReactions)
               .HasForeignKey(e => e.MovieId)
               .IsRequired();

            builder.HasOne(e => e.User)
                   .WithMany(e => e.MovieReactions)
                   .HasForeignKey(e => e.UserId)
                   .IsRequired();
        }
    }
}
